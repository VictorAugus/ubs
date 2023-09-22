public without sharing class CommunityLoginController {
    public static String  loginToCommunity() {
        String clientId = '3MVG9gDRuIiLyYCq._oSu9IvWDlEUCl76F5fy90eLyt0twM6tBlgek5fsoLWFDGjSZnUjH5pUT6Hj9vwrNaAf'; // Substitua pelo seu Consumer Key.
        String clientSecret = '96D7045C5D059F882FAFB2549A406C58FB4BC8A64BFBA7151AD47891193A6680'; // Substitua pelo seu Consumer Secret.
        String username = ' v.pecuch@daspeweb.com.br.developer'; // Substitua pelo nome de usuário.
        String password = 'Daspe@2026SJVuBLTtaJkzT9q1gR99QWGvC'; // Substitua pela senha.
        
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://daspeweb-e-dev-ed.develop.my.salesforce.com/services/oauth2/token');
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        req.setBody('grant_type=password&client_id=' + clientId + '&client_secret=' + clientSecret + '&username=' + username + '&password=' + password);
        
        Http http = new Http();
        HttpResponse res = http.send(req);
        
        if (res.getStatusCode() == 200) {
            Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
            String sessionCookie = (String) responseMap.get('access_token');
            return sessionCookie;
        } else {
            // Lida com falhas de autenticação aqui
            return null;
        }
    }
}