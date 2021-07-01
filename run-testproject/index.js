const core = require('@actions/core')
const axios = require('axios')
const BASE_URL = 'https://api.testproject.io'
const REQUEST_WAIT = 20000 // 20 seconds
const FINISHED_JOB_STATES = ['Failed', 'Passed', 'Skipped', 'Suspended', 'Error', 'Aborted']

function pollExecutionStatus(executionId, headers, inputs) {
    setTimeout(async () => {
        const status = await getExecutionStatus(executionId, headers, inputs)
        core.info(`Tests are running. Current status: "${status}"`)
        if (status instanceof Error) {
            throw status
        }

        const isDone = FINISHED_JOB_STATES.includes(status)

        if (isDone) {
            completeWorkflow(status)
        } else {
            pollExecutionStatus(executionId, headers, inputs)
        }
    }, REQUEST_WAIT)
}

async function getExecutionStatus(executionId, headers, inputs) {
    const uri = `${BASE_URL}/v2/projects/${inputs.projectId}/jobs/${inputs.jobId}/executions/${executionId}/state`

    return axios.get(uri, { headers })
        .then(res => res.data.state)
}

async function runJob(headers, inputs) {
    const uri = `${BASE_URL}/v2/projects/${inputs.projectId}/jobs/${inputs.jobId}/run`
    const body = { agentId: inputs.agentId }

    return axios.post(uri, body, { headers })
        .then(res => res.data.id)
}

async function runWorkflow(headers, inputs) {
    const executionId = await runJob(headers, inputs)
    if (executionId instanceof Error) {
        throw executionId
    }

    pollExecutionStatus(executionId, headers, inputs)
}

async function completeWorkflow(status) {
    if (status === 'Passed') {
        core.info('Tests passed!')
    } else {
        core.setFailed(`Tests did not pass or were aborted. TestProject status: "${status}"`)
    }
}

async function run() {
    try {
        const inputs = {
            projectId: core.getInput('project-id', { required: true }),
            jobId: core.getInput('job-id', { required: true }),
            agentId: core.getInput('agent-id', { required: true }),
            apiKey: core.getInput('api-key', { required: true }),
        }

        const headers = {
            'Authorization': inputs.apiKey,
            'Content-Type': 'application/json',
        }

        runWorkflow(headers, inputs)
    } catch (error) {
        core.setFailed(error.message)
    }
}

run()
