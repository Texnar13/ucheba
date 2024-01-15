package com.example.lw1;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.CommandLineRunner;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.thymeleaf.spring6.SpringTemplateEngine;
import org.thymeleaf.spring6.view.ThymeleafViewResolver;

import java.nio.charset.StandardCharsets;


@Configuration
class BeerAppConfiguration {

    private static final Logger log = LoggerFactory.getLogger(BeerAppConfiguration.class);


//    @Bean
//    public ThymeleafViewResolver viewResolver(SpringTemplateEngine templateEngine){
//        ThymeleafViewResolver viewResolver = new ThymeleafViewResolver();
//        viewResolver.setContentType("application/json");
//        viewResolver.setCharacterEncoding(StandardCharsets.UTF_8.name());
//        viewResolver.setOrder(1);
//        viewResolver.setViewNames(new String[] {"*.json"});
//        viewResolver.setTemplateEngine(templateEngine);
//        return viewResolver;
//    }

    @Bean
    CommandLineRunner initDatabase(BeerRepo repository) {
        // Источник: https://she-win.ru/interesnoe/top-33-luchshego-piva-v-rossii-rejting-na-2022
        return args -> {
            log.info("Preloading Beer new: " + repository.save(new Beer(
                    "Franziskaner нефильтрованное",
                    "Германия",
                    109,
                    "Вкус; Никакой горечи; Качество; Самомаркировка;",
                    "Высокая стоимость;"
            )));
            log.info("                new: " + repository.save(new Beer(
                    "Anderson Valley",
                    "США",
                    240,
                    "Оттенок; Вкус; Никакой горечи; Сладкое послевкусие; Баланс;",
                    "Трудно найти; Цена;"
            )));
            log.info("                new: " + repository.save(new Beer(
                    "«Gulden Draak» 9000",
                    "Бельгиия",
                    319,
                    "Необычно; Дизайн; Цвет; Качество;",
                    "Невыразительный вкус; Цена;"
            )));
            log.info("                new: " + repository.save(new Beer(
                    "Bayreuther Hell",
                    "Германия",
                    242,
                    "Натуральное сырье; Приготовление на высоком уровне; Сбалансированный вкус; Свежий приятный аромат;",
                    ""
            )));
            log.info("                new: " + repository.save(new Beer(
                    "Franziskaner Hefe-Weisse",
                    "Германия",
                    139,
                    "Нефильтрованное; Мягкий освежающий вкус; Густой; Ярко выраженный пшеничный аромат;",
                    "Дорого; Слегка резковатое послевкусие (по отзывам);"
            )));
            log.info("                new: " + repository.save(new Beer(
                    "Leffe Brune",
                    "Германия",
                    170,
                    "Красивый темно-кофейный цвет; Аромат карамели и кофе; Затяжная темная голова; Вкус сладкий и карамельный, с легкой горечью; Фильтруется, легко пьется;",
                    "Высокая цена; Может показаться слишком сладким;"
            )));
            log.info("                new: " + repository.save(new Beer(
                    "Bourgogne des Flandres Brune",
                    "Бельгия",
                    250,
                    "Кисло-сладкий вкус с фруктовыми нотками, без горечи; Настойчивая голова; Легко пьется;",
                    "Вряд ли удовлетворит любителей светлого пива;"
            )));
            log.info("                new: " + repository.save(new Beer(
                    "Velvet",
                    "Чехия",
                    150,
                    "Деликатный полный вкус с легкой горечью; Плотная, бархатистая голова; Приятно пить;",
                    "относительно высокая цена;"
            )));
            log.info("                new: " + repository.save(new Beer(
                    "Bernard Svatecni Lezak",
                    "Чехия",
                    291,
                    "Хорошо различимый натуральный солодовый вкус без горечи; Легкий намек на хмель в послевкусии; Приятный аромат и пышная шапка пены; После розлива в бутылки пиво подвергается вторичной фильтрации;",
                    "Не всем нравится его вкус — по отзывам, он горький;"
            )));
            log.info("                new: " + repository.save(new Beer(
                    "Schlenkerla копченое пиво",
                    "Германия",
                    282,
                    "многогранный вкус; тонкая карбонизация; немецкое качество; хорошее гастрономическое сочетание;",
                    "относительно высокая цена;"
            )));
            log.info("                new: " + repository.save(new Beer(
                    "Augustiner – немецкий лагер",
                    "Германия",
                    320,
                    "приятный вкус; средняя прочность; высокое качество; хорошее гастрономическое сочетание;",
                    "дорого;"
            )));
            log.info("                new: " + repository.save(new Beer(
                    "Guinness",
                    "Ирландия",
                    223,
                    "очень густая голова; традиционне пиво; азотный шарик создающий пену при открытии банки;",
                    "относительно высокая цена;"
            )));
            log.info("                new: " + repository.save(new Beer(
                    "Канализационная нефильтрованная",
                    "Великое подземье",
                    10,
                    "Вкус;",
                    "Можно попробовать только 1 раз;"
            )));

        };
    }
}