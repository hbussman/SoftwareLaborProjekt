package sponsoren.service.external;

import org.springframework.core.ParameterizedTypeReference;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Repository;
import org.springframework.web.client.RestTemplate;
import sponsoren.service.external.Attraktionen.Attraktion;
import sponsoren.service.external.Lageplan.Poi;

import java.util.List;

@Repository
public class ExternalServices {

    public List<Attraktion> getAttraktionen () {
        RestTemplate restTemplate = new RestTemplate();
        ResponseEntity<List<Attraktion>> rateResponse = restTemplate.exchange(
                "https://seserver.se.hs-heilbronn.de:9443/buga19attractions/get/attractions",
                HttpMethod.GET, null, new ParameterizedTypeReference<List<Attraktion>>() {});
        List<Attraktion> attraktionen = rateResponse.getBody();
        return attraktionen;
    }

    public List<Poi> getPois () {
        RestTemplate restTemplate = new RestTemplate();
        ResponseEntity<List<Poi>> rateResponse = restTemplate.exchange(
                "https://seserver.se.hs-heilbronn.de:3000/pois",
                HttpMethod.GET, null, new ParameterizedTypeReference<List<Poi>>() {});
        List<Poi> pois = rateResponse.getBody();
        return pois;
    }

}
