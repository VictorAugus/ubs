public class LoginController {

    public String username { get; set; }
    public String password { get; set; }
    
    public PageReference login() {
        String communityUrl = 'https://daspeweb-e-dev-ed.develop.my.site.com/s/'; // Substitua pelo URL da sua comunidade
        
        HttpRequest req = new HttpRequest();
        req.setEndpoint(communityUrl + '/services/oauth2/token');
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        
        String clientId = '3MVG9gDRuIiLyYCq._oSu9IvWDlEUCl76F5fy90eLyt0twM6tBlgek5fsoLWFDGjSZnUjH5pUT6Hj9vwrNaAf';
        String clientSecret = '96D7045C5D059F882FAFB2549A406C58FB4BC8A64BFBA7151AD47891193A6680';
        String requestParams = 'grant_type=password&client_id=' + clientId + '&client_secret=' + clientSecret +
                               '&username=' + username + '&password=' + password;
        req.setBody(requestParams);
        
        Http http = new Http();
        HttpResponse res = http.send(req);
        
        if (res.getStatusCode() == 200) {
            Map<String, Object> authResponse = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
            String authToken = (String) authResponse.get('access_token');
            
            // Crie um cookie
            Cookie authCookie = new Cookie('AuthToken', authToken, null, -1, false);
            
            // Adicione o cookie à resposta HTTP
            ApexPages.currentPage().setCookies(new Cookie[]{authCookie});
            
            return Page.PaginaComCookie; // Substitua pelo nome da sua página com o cookie
        } else {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Erro de autenticação'));
            return null;
        }
    }
}