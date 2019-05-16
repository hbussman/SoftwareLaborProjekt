package sponsoren.service.external.Attraktionen;

import org.springframework.core.ParameterizedTypeReference;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Repository;
import org.springframework.web.client.RestTemplate;
import sponsoren.service.external.Attraktionen.Attraktion;

import java.util.List;

@Repository
public class AttraktionenApi {

    public List<Attraktion> getAttraktionen () {
        RestTemplate restTemplate = new RestTemplate();
        ResponseEntity<List<Attraktion>> rateResponse = restTemplate.exchange("http://seserver.se.hs-heilbronn.de:9080/buga19attractions/get/attractions",
                        HttpMethod.GET, null, new ParameterizedTypeReference<List<Attraktion>>() {
                        });
        List<Attraktion> Attraktion = rateResponse.getBody();
        return Attraktion;
    }


}
