import { validateToken, Callback, Context } from '../layers/common';

/**
 * Pseudocode for the auth gateway lambda function based on:
 * https://docs.aws.amazon.com/apigateway/latest/developerguide/apigateway-use-lambda-authorizer.html
 *
 * Use the callback to return the policy document
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
  const authResponse = {} as any;
  authResponse.principalId = principal;
  if (effect && resource) {
    const policyDocument = {} as any;
    policyDocument.Version = '2012-10-17';
    policyDocument.Statement = [] as any;
    const statementOne = {} as any;
    statementOne.Action = 'execute-api:Invoke';
    statementOne.Effect = effect;
    statementOne.Resource = resource;
    policyDocument.Statement[0] = statementOne;
    authResponse.policyDocument = policyDocument;
  }
  return authResponse;
};
