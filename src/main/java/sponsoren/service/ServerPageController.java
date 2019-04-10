package sponsoren.service;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class ServerPageController {

  @GetMapping({"/", "/index"})
  public String hello(Model model) {
    return "index";
  }

}
