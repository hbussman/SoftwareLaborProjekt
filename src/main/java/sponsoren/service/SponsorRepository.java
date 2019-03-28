package sponsoren.service;

import org.springframework.data.repository.CrudRepository;
import sponsoren.orm.SponsorEntity;

public interface SponsorRepository extends CrudRepository<SponsorEntity, String> {
    // AUTO IMPLEMENTED by spring
}
