package sponsoren.service;

import org.springframework.data.repository.CrudRepository;
import sponsoren.orm.LocationEntity;

public interface LocationRepository extends CrudRepository<LocationEntity, String> {
    // AUTO IMPLEMENTED by spring
}
