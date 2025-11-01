package com.ProyectoTenis.demo.controller;

import com.ProyectoTenis.demo.domain.Categoria;
import com.ProyectoTenis.demo.service.CategoriaService;
import jakarta.validation.Valid;
import java.util.List;
import java.util.Locale;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequestMapping("/categoria")
public class CategoriaController {

    @Autowired
    private CategoriaService categoriaService;

    @Autowired
    private MessageSource messageSource;

    @GetMapping("/listado")
    public String listado(Model model) {
        List<Categoria> lista = categoriaService.getCategorias();
        model.addAttribute("categorias", lista);
        model.addAttribute("totalCategorias", lista.size());
        return "/categoria/listado";
    }

    @PostMapping("/guardar")
    public String guardar(@Valid Categoria categoria,
                          RedirectAttributes redirectAttributes) {

        categoriaService.save(categoria);

        redirectAttributes.addFlashAttribute("todoOk",
                messageSource.getMessage("mensaje.guardado", null, Locale.getDefault()));

        return "redirect:/categoria/listado";
    }

    @GetMapping("/eliminar")
    public String eliminar(@RequestParam Long idCategoria,
                           RedirectAttributes redirectAttributes) {

        categoriaService.delete(idCategoria);

        redirectAttributes.addFlashAttribute("todoOk",
                messageSource.getMessage("mensaje.eliminado", null, Locale.getDefault()));

        return "redirect:/categoria/listado";
    }

    @GetMapping("/modificar/{idCategoria}")
    public String modificar(@PathVariable Long idCategoria, Model model) {

        Categoria categoria;
        if (idCategoria == 0) {
            categoria = new Categoria();
        } else {
            categoria = categoriaService.getCategoria(idCategoria).orElse(null);
            if (categoria == null) {
                return "redirect:/categoria/listado";
            }
        }

        model.addAttribute("categoria", categoria);
        return "/categoria/modifica";
    }
}
