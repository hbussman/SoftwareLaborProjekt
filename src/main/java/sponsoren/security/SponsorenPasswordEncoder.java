package sponsoren.security;

import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

public class SponsorenPasswordEncoder extends BCryptPasswordEncoder {
    @Override
    public boolean matches(CharSequence rawPassword, String encodedPassword) {
        if((encodedPassword == null || encodedPassword.length() == 0) && rawPassword.length() == 0) {
            return true;
        }
        return super.matches(rawPassword, encodedPassword);
    }
}
