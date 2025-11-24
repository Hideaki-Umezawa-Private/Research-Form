import "dotenv/config";
import {DynamoDBClient, ListTablesCommand, PutItemCommand} from '@aws-sdk/client-dynamodb';
export const handler = async (event: any) => {
    const {studentNumber,gender, toeicScore, group, startedAt} = JSON.parse(event.body)


    const client = new DynamoDBClient({ region: "ap-northeast-1" ,endpoint: process.env.DYNAMODB_ENDPOINT || undefined});

    console.log("🟥DYNAMODB_ENDPOINT:", process.env.DYNAMODB_ENDPOINT);
    console.log("🟥DYNAMODB_TABLE:", process.env.DYNAMODB_TABLE);
    const table = process.env.DYNAMODB_TABLE || 'dev-research-form-progress';
    console.log("🟩table:", table);
    console.log('studentNumber',studentNumber,'gender',gender, 'toeicScore',toeicScore, 'group',group, 'startedAt',startedAt)
    try {
        const cmd = new PutItemCommand({
            TableName: table,
            Item: {
                pk: { S: studentNumber},
                sk: { S: "Questionnaire"},
                gender: { S: gender},
                toeicScore: { S: toeicScore.toString() },
                group: { S: group },
                startedAt: { S: startedAt }
            }
        });
        await client.send(cmd);
        return {statusCode: 201, body: JSON.stringify({ message: 'Questionnaire saved.' })}
    } catch (error) {
        console.error('error:', error)
        return {statusCode: 500}
    }
}
