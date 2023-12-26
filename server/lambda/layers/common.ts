import { SecretsManager } from '@aws-sdk/client-secrets-manager';
import jwt, { JwtPayload } from 'jsonwebtoken';
import { CloudFrontRequestHandler, CloudFrontHeaders } from 'aws-lambda';

export { CloudFrontRequestHandler, CloudFrontHeaders };

let SecretsManagerClient = new SecretsManager({
  region: 'aws-region',
});

/**
 * Validate the token signature and expiration date
 * @param token the jwt token to validate
 * @returns
 */
export const validateToken = async (token: string): Promise<boolean> => {
  // 1. Check secrets manager
  const jwtSecret = await SecretsManagerClient.getSecretValue({
    SecretId: 'auth-jwt-secret',
  });

  if (jwtSecret !== undefined && jwtSecret.SecretString !== undefined) {
    const secret = JSON.parse(jwtSecret.SecretString).secret;
    try {
      const decoded = jwt.verify(token, secret) as JwtPayload;

      if (decoded.exp && Date.now() >= decoded.exp * 1000) {
        console.warn('Token expired');
      } else {
        return true;
      }
    } catch (err) {
      console.log(err);
    }
  } else {
    // 2. Call auth service
    try {
      const valid = await fetch(process.env['AUTH_URL'] + '/validate', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({ token }),
      });

      return valid.status === 200;
    } catch (err) {
      console.log(err);
    }
  }
  return false;
};

/**
 *  Validate the token claims grant access to the resource
 * @param token the jwt token to validate
 * @param resource the resource to be accessed
 * @returns
 */
export const validateTokenClaims = async (token: string, resource: string) => {
  const claims = jwt.decode(token) as JwtPayload;
  const someClaim = claims[''];

  // TODO: Validate claim gives access to resource
  return someClaim === 'resource';
};
