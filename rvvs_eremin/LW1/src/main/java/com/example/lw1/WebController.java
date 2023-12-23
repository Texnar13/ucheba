package com.example.lw1;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
public class WebController {


    private final BeerRepo beerRepository;


    WebController(BeerRepo repository) {
        this.beerRepository = repository;
    }


    // http://localhost:8080
    // базовая страница
    @GetMapping("/")
    String myTest(Model model) {

//        Beer creatingBeer = new Beer();
//        model.addAttribute("creating_beer", creatingBeer);

        return "index";
    }


    @GetMapping(value = "/beer/{id}")
    public String getBeer(Model model, @PathVariable("id") Long id) throws BeerNotFoundException {

        Beer beerUnit = beerRepository.findById(id)
                .orElseThrow(() -> new BeerNotFoundException(id));

        model.addAttribute("beerUnit", beerUnit);

        return "beerUnitView";
    }


    // создание пива
    @PostMapping(value = "/beer")
    public String addBeer(
            Model model,
            @RequestParam("beerName") String beerName,
            @RequestParam("beerCountry") String country,
            @RequestParam("beerCost") int cost,
            @RequestParam("beerAdvantages") String advantages,
            @RequestParam("beerDisadvantages") String disadvantages
    ) {

        // Добавляем созданное пиво в БД и получаем ID
        Beer createdBeer = beerRepository.saveAndFlush(
                // создаем пиво
                new Beer(
                        beerName, country, cost, advantages, disadvantages
                )
        );

        // добавляем обьект в конструктор выводимой страницы
        model.addAttribute("createdBeer", createdBeer);
        // Выводим разметку beerCreated
        return "beerCreated";
    }

    // редактирование пива
    @PostMapping(value = "/beerEdit")
    public String updateBeer(
            Model model,
            @RequestParam("beerID") long beerId,
            @RequestParam("beerName") String beerName,
            @RequestParam("beerCountry") String country,
            @RequestParam("beerCost") int cost,
            @RequestParam("beerAdvantages") String advantages,
            @RequestParam("beerDisadvantages") String disadvantages)
            throws BeerNotFoundException {

        // ищем указанное пиво
        Beer beerUnit = beerRepository.findById(beerId)
                .orElseThrow(() -> new BeerNotFoundException(beerId));
        // обновление пива
        beerUnit.setName(beerName);
        beerUnit.setCountry(country);
        beerUnit.setCost(cost);
        beerUnit.setAdvantages(advantages);
        beerUnit.setDisadvantages(disadvantages);
        beerRepository.save(beerUnit);

        // показываем то что получилось
        // model.addAttribute("beerUnit", beerUnit);

        model.addAttribute("message", "Параметры успешно изменены!");
        return "beerState";
    }

    // Удаление пива
    @PostMapping(value = "/beerDelete")
    public String deleteBeer(Model model, @RequestParam("beerId") long id) {
        beerRepository.deleteById(id);

        model.addAttribute("message", "Пиво успешно удалено!");
        return "beerState";
    }


    // ---------------------- View beer lists ----------------------
    @RequestMapping(value = "/all_beer", method = RequestMethod.GET)
    public String getAllBeer(Model model) {
        model.addAttribute("beerList", beerRepository.findAll());
        return "allBeerList";
    }

    // Постраничо
    @GetMapping(value = "/beer_list")
    public String listBeer(
            Model model,
            @RequestParam(name = "page", defaultValue = "0") int page,
            @RequestParam(name = "size", defaultValue = "5") int size) {

        if (page < 0) page = 0;
        if (size < 1) size = 1;


        Page<Beer> beerPage = beerRepository.findAll(PageRequest.of(page, size));

        model.addAttribute("beerList", beerPage);

        return "beerPage";
    }
}
