# Docker Config for Jenkins

Jenkins uses docker configuration to build and push images to image registry. `BASE64_ENCODED_JENKINS_CFG` represents docker config in JSON which resides usually at `/home/$USER/.docker/config.json`. Following docker config is an example which can be used as `BASE64_ENCODED_JENKINS_CFG` encoded in Base64 as per requirement. In the following example the default "auth" value is base64 representation of the default nexus username:password i.e. `user-admin:stakater@qwerty786`

```
{
  "auths": {
    "docker-delivery.workshop.stakater.com:443": {
      "auth": "dXNlci1hZG1pbjpzdGFrYXRlckBxd2VydHk3ODY="
    }
  }
}
```