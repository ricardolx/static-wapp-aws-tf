import {
  validateTokenClaims,
  validateToken,
  CloudFrontRequestHandler,
  CloudFrontHeaders,
} from '../layers/common';

type Cookies = { [key: string]: string };

/**
 * This is pseudeocode for the auth at edge lambda function based on:
 * https://github.com/aws-samples/cloudfront-authorization-at-edge/blob/master/src/lambda-edge/check-auth/index.ts
 * 
 * If the authorization succeeds, the request is returned unmodified.
 * If the authorization fails, the request is redirected to the login page.
 * 
 * This can be customized to redirect to a specific page, such as an error, refresh, or login page
 * @param event a cloudfront event
 * @returns
 */
export const handler: CloudFrontRequestHandler = async (event: any) => {
  const request = event.Records[0].cf.request;

  const requestedUri = `${request.uri}${
    request.querystring ? '?' + request.querystring : ''
  }`;

  const headers = request.headers as CloudFrontHeaders;

  const cookies = headers['cookie'].reduce(
    (reduced, header) => Object.assign(reduced, JSON.parse(header.value)),
    {} as Cookies
  );

  const token = cookies['idToken'];

  const validSignature = await validateToken(token);
  if (validSignature) {
    const validClaims = await validateTokenClaims(token, requestedUri);
    if (validClaims) {
      return request;
    }
  }
  return {
    status: '307',
    statusDescription: 'Temporary Redirect',
    headers: {
      location: [
        {
          key: 'location',
          value: `https://${process.env['SIGN_IN_URL']}`,
        },
      ],
    },
  };
};
