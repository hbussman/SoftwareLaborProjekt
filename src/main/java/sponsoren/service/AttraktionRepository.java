package sponsoren.service;

import org.springframework.data.repository.CrudRepository;
import sponsoren.orm.AttraktionEntity;
import sponsoren.orm.AttraktionEntityPK;

public interface AttraktionRepository extends CrudRepository<AttraktionEntity, AttraktionEntityPK> {
    // AUTO IMPLEMENTED by spring
}
