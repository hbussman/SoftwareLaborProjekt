package sponsoren.service;

import org.springframework.data.repository.CrudRepository;
import sponsoren.orm.SponsorVeranstaltungEntity;

public interface SponsorVeranstaltungRepository extends CrudRepository<SponsorVeranstaltungEntity, String> {
    // AUTO IMPLEMENTED by spring
}
