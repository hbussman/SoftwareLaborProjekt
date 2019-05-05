package sponsoren.service;

import org.springframework.data.repository.CrudRepository;
import sponsoren.orm.SponsorVeranstaltungEntity;
import sponsoren.orm.SponsorVeranstaltungEntityPK;

public interface SponsorVeranstaltungRepository extends CrudRepository<SponsorVeranstaltungEntity, SponsorVeranstaltungEntityPK> {
    // AUTO IMPLEMENTED by spring
}
