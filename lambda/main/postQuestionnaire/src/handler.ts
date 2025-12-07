import {DynamoDBClient} from '@aws-sdk/client-dynamodb';
import {DynamoDBDocumentClient, PutCommand} from '@aws-sdk/lib-dynamodb';

export const handler = async (event: any) => {
    const {studentNumber, gender, toeicScore, group, startedAt} = JSON.parse(event.body)

    const baseClient = new DynamoDBClient({
        region: 'ap-northeast-1',
        endpoint: process.env.DYNAMODB_ENDPOINT || 'http://localstack:4566'
    });
    const client = DynamoDBDocumentClient.from(baseClient)
    const table = process.env.DYNAMODB_TABLE || 'dev-research-form-progress';

    try {
        const command = new PutCommand({
            TableName: table,
            Item: {
                pk: studentNumber,
                sk: 'QUESTIONNAIRE',
                entityType: 'QUESTIONNAIRE',
                gender,
                toeicScore,
                group,
                startedAt
            }
        });
        await client.send(command);
        return {statusCode: 201, body: JSON.stringify({message: 'Questionnaire saved.'})}
    } catch (error) {
        console.error('error:', error)
        return {statusCode: 500}
    }
}
