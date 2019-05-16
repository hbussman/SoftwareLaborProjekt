package sponsoren.service;

import org.springframework.data.repository.CrudRepository;
import sponsoren.orm.SponsorAttraktionEntity;
import sponsoren.orm.SponsorAttraktionEntityPK;
import sponsoren.orm.SponsorVeranstaltungEntity;
import sponsoren.orm.SponsorVeranstaltungEntityPK;

public interface SponsorAttraktionRepository extends CrudRepository<SponsorAttraktionEntity, SponsorAttraktionEntityPK> {
    // AUTO IMPLEMENTED by spring
}
