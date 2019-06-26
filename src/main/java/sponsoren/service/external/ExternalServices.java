package sponsoren.service.external;

import org.springframework.core.ParameterizedTypeReference;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Repository;
import org.springframework.web.client.RestTemplate;
import sponsoren.service.external.Attraktionen.Attraktion;
import sponsoren.service.external.Lageplan.Poi;

import javax.net.ssl.HttpsURLConnection;
import javax.net.ssl.SSLContext;
import javax.net.ssl.TrustManager;
import javax.net.ssl.X509TrustManager;
import java.security.cert.X509Certificate;
import java.util.List;

@Repository
public class ExternalServices {

    private static final TrustManager[] UNQUESTIONING_TRUST_MANAGER = new TrustManager[] {
            new X509TrustManager() {
                public java.security.cert.X509Certificate[] getAcceptedIssuers(){
                    return null;
                }
                public void checkClientTrusted( X509Certificate[] certs, String authType ){}
                public void checkServerTrusted(X509Certificate[] certs, String authType ){}
            }
    };

    private RestTemplate getRestTemplate() {
        final SSLContext sc;
        try {
            sc = SSLContext.getInstance("SSL");
            sc.init( null, UNQUESTIONING_TRUST_MANAGER, null);
            HttpsURLConnection.setDefaultSSLSocketFactory(sc.getSocketFactory());
        } catch(Exception e) {
            throw new RuntimeException(e);
        }

        RestTemplate restTemplate = new RestTemplate();
        return restTemplate;
    }


    public List<Attraktion> getAttraktionen () {
        ResponseEntity<List<Attraktion>> rateResponse = getRestTemplate().exchange(
                "https://seserver.se.hs-heilbronn.de:9443/buga19bugascout-backend/get/attractions",
                HttpMethod.GET, null, new ParameterizedTypeReference<List<Attraktion>>() {});
        List<Attraktion> attraktionen = rateResponse.getBody();
        return attraktionen;
    }

    public List<Poi> getPois () {
        ResponseEntity<List<Poi>> rateResponse = getRestTemplate().exchange(
                "https://seserver.se.hs-heilbronn.de:3000/api/pois",
                HttpMethod.GET, null, new ParameterizedTypeReference<List<Poi>>() {});
        List<Poi> pois = rateResponse.getBody();
        return pois;
    }

}
