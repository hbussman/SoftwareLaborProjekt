package sponsoren.security;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;
import sponsoren.orm.AccountEntity;
import sponsoren.service.AccountRepository;

@Service
public class CustomUserDetailsService implements UserDetailsService {
    @Autowired
    private AccountRepository userRepository;


    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        AccountEntity user = userRepository.findById(username).orElse(null);

        if (user == null) {
            throw new UsernameNotFoundException(username);
        }
        return new CustomUserPrincipal(user);
    }
}
