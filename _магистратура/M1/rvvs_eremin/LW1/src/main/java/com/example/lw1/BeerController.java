package com.example.lw1;

import org.springframework.web.bind.annotation.*;


@RestController
public class BeerController {

    private final BeerRepo beerRepository;


    BeerController(BeerRepo repository) {
        this.beerRepository = repository;
    }


    // ---------------------- Work with a single beer ----------------------


    @DeleteMapping(value = "/beer/{id}")
    public void deleteBeer(@PathVariable("id") Long id) {
        System.out.println(id);
        beerRepository.deleteById(id);
    }

    @PutMapping("/replace_beer/{id}")
    Beer replaceBeer(@RequestBody Beer replaceB, @PathVariable Long id) {

        return beerRepository.findById(id).map(employee -> {
            employee.setName(replaceB.getName());
            employee.setCountry(replaceB.getCountry());
            employee.setCost(replaceB.getCost());
            employee.setAdvantages(replaceB.getAdvantages());
            employee.setDisadvantages(replaceB.getDisadvantages());
            return beerRepository.save(employee);
        }).orElseGet(() -> {
            replaceB.setId(id);
            return beerRepository.save(replaceB);
        });
    }
}
