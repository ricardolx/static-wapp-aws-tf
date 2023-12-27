import { validateToken, Callback, Context } from '../layers/common';

/**
 * Pseudocode for the auth gateway lambda function based on:
 * https://docs.aws.amazon.com/apigateway/latest/developerguide/apigateway-use-lambda-authorizer.html
 *
 * Use the callback to return the policy document which allows access to invoke the underlying resource, such as an Application Load Balancer
 * @param event
 * @param context
 * @param callback
 */
export const handler = async (
  event: any,
  context: Context,
  callback: Callback
) => {
  const token = event.headers['authorization'];

  if (!token) {
    callback('Unauthorized');
  }

  const validSignature = await validateToken(token);

  if (validSignature) {
    callback(null, generatePolicy('user', 'Allow', event.methodArn));
  }

  callback('Unauthorized');
};

const generatePolicy = (
  principal: string,
  effect: string,
  resource: string
) => {
  const authResponse = {
    principalId: 'user',
    policyDocument: {
      Version: '2012-10-17',
      Statement: [
        {
          Action: 'execute-api:Invoke',
          Effect: 'Allow',
          Resource:
            `arn:aws:execute-api:region:account-id:api-id/stage/method/${resource}`,
        },
      ],
    },
  };
  return authResponse;
};
