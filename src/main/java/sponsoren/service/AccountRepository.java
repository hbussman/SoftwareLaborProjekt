package sponsoren.service;

import org.springframework.data.repository.CrudRepository;
import sponsoren.orm.AccountEntity;

public interface AccountRepository extends CrudRepository<AccountEntity, String> {
    // AUTO IMPLEMENTED by spring
}
