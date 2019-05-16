package sponsoren.service;

import org.springframework.data.repository.CrudRepository;
import sponsoren.orm.AttraktionEntity;
import sponsoren.orm.SponsorAttraktionEntityPK;

public interface AttraktionRepository extends CrudRepository<AttraktionEntity, SponsorAttraktionEntityPK> {
    // AUTO IMPLEMENTED by spring
}
