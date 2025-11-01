package com.ProyectoTenis.demo.controller;

import com.ProyectoTenis.demo.service.TenisService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class IndexController {

    private final TenisService tenisService;

    public IndexController(TenisService tenisService) {
        this.tenisService = tenisService;
    }

    @GetMapping("/")
    public String cargarPaginaInicio(Model model) {
        var listaTenis = tenisService.getTenis();
        model.addAttribute("tenis", listaTenis);
        model.addAttribute("totalTenis", listaTenis.size());
        return "/index";
    }
}
