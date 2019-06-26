package sponsoren.service;

import org.springframework.data.repository.CrudRepository;
import sponsoren.orm.AttraktionEntity;

public interface AttraktionRepository extends CrudRepository<AttraktionEntity, String> {
    // AUTO IMPLEMENTED by spring
}
