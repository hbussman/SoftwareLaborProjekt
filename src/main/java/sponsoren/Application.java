package sponsoren;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.web.servlet.support.SpringBootServletInitializer;
import org.springframework.boot.builder.SpringApplicationBuilder;
import sponsoren.service.AttraktionRepository;
import sponsoren.service.external.Attraktion;

@SpringBootApplication
public class Application extends SpringBootServletInitializer {

    @Override
    protected SpringApplicationBuilder configure(SpringApplicationBuilder application) {
        return application.sources(Application.class);
    }

    public static void main(String[] args) {
        SpringApplication.run(Application.class, args);
        AttraktionRepository attraktionRepository = new AttraktionRepository();
        System.out.println(attraktionRepository.getAttraktionen().get(2));
    }
}
