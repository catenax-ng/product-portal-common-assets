window.onload = function() {
  window.ui = SwaggerUIBundle({
    dom_id: '#swagger-ui',
    deepLinking: true,
    filter: true,
    presets: [
      SwaggerUIBundle.presets.apis,
      SwaggerUIStandalonePreset
    ],
    plugins: [
      SwaggerUIBundle.plugins.DownloadUrl
    ],
    layout: 'StandaloneLayout',
    configUrl: location.hostname === 'portal.int.demo.catena-x.net'
      ? `https://portal.int.demo.catena-x.net/assets/api/swagger/int.json`
      : `https://portal.dev.demo.catena-x.net/assets/api/swagger/dev.json`,
    requestInterceptor: (req) => {
      req.headers.Authorization = `Bearer ${keycloak.token}`
      return req
    },
  })
  window.ui.initOAuth({
    clientId: 'catenax-portal',
    scopes: 'openid profile',
    usePkceWithAuthorizationCodeGrant: 'true'
  })
  setTimeout(selectAPI, 100)
}
