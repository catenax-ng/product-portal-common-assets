window.onload = function() {
  //<editor-fold desc="Changeable Configuration Block">

  // the following lines will be replaced by docker/configurator, when it runs in a docker-container
  //url: "https://petstore.swagger.io/v2/swagger.json",
  window.ui = SwaggerUIBundle({
    dom_id: '#swagger-ui',
    deepLinking: true,
    presets: [
      SwaggerUIBundle.presets.apis,
      SwaggerUIStandalonePreset
    ],
    plugins: [
      SwaggerUIBundle.plugins.DownloadUrl
    ],
    layout: 'StandaloneLayout',
    configUrl: '/swagger/api/swagger-config.json',
    requestInterceptor: (req) => {
      req.headers.Authorization = `Bearer ${keycloak.token}`
      return req
    }
      //validatorUrl: ""
  });
  window.ui.initOAuth({
    "clientId":"catenax-portal",
    "scopes":"openid profile",
    "usePkceWithAuthorizationCodeGrant":"true"
  });
  //</editor-fold>
};
