package sponsoren.service;

import org.springframework.data.repository.CrudRepository;
import sponsoren.orm.VeranstaltungEntity;

public interface VeranstaltungRepository extends CrudRepository<VeranstaltungEntity, Integer> {
    // AUTO IMPLEMENTED by spring
}
