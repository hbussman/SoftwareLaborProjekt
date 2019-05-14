package sponsoren.service;

import java.util.List;

import org.springframework.data.repository.CrudRepository;
import sponsoren.orm.SponsorEntity;

public interface SponsorRepository extends CrudRepository<SponsorEntity, String> {

	List<SponsorEntity> findBySpendenklasse(byte b);
    // AUTO IMPLEMENTED by spring
}
