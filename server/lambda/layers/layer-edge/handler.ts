import { validateTokenClaims, validateToken } from '../common';

exports.handler = async (event: any) => {
  const { token, resource } = event;
  const validSignature = await validateToken(token);
  if (validSignature) {
    const validClaims = await validateTokenClaims(token, resource);
    if (validClaims) {
      return {
        statusCode: 200,
        body: JSON.stringify({ message: 'Valid token' }),
      };
    }
  }
  return {
    statusCode: 401,
    body: JSON.stringify({ message: 'Invalid token' }),
  };
};
