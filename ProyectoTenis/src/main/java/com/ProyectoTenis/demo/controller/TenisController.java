package com.ProyectoTenis.demo.controller;

import com.ProyectoTenis.demo.domain.Tenis;
import com.ProyectoTenis.demo.service.TenisService;
import jakarta.validation.Valid;
import java.util.List;
import java.util.Locale;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequestMapping("/tenis")
public class TenisController {

    @Autowired
    private TenisService tenisService;

    @Autowired
    private MessageSource messageSource;

    @GetMapping("/listado")
    public String listado(Model model) {
        List<Tenis> listaTenis = tenisService.getTenis();
        model.addAttribute("tenis", listaTenis);
        model.addAttribute("totalTenis", listaTenis.size());
        return "/tenis/listado";
    }

    @PostMapping("/guardar")
    public String guardar(@Valid Tenis tenis,
                          @RequestParam("imagenFile") MultipartFile imagenFile,
                          RedirectAttributes redirectAttributes) {

        tenisService.save(tenis, imagenFile);

        redirectAttributes.addFlashAttribute("todoOk",
                messageSource.getMessage("mensaje.guardado", null, Locale.getDefault()));

        return "redirect:/tenis/listado";
    }

    @GetMapping("/eliminar")
    public String eliminar(@RequestParam Long id,
                           RedirectAttributes redirectAttributes) {

        String titulo = "todoOk";
        String detalle = "mensaje.eliminado";

        try {
            tenisService.delete(id);
        } catch (IllegalArgumentException e) {
            titulo = "error";
            detalle = "tenis.error01";
        } catch (Exception e) {
            titulo = "error";
            detalle = "tenis.error02";
        }

        redirectAttributes.addFlashAttribute(titulo,
                messageSource.getMessage(detalle, null, Locale.getDefault()));

        return "redirect:/tenis/listado";
    }

    @GetMapping("/modificar/{id}")
    public String modificar(@PathVariable Long id, Model model) {

        Tenis tenis;
        if (id == 0) {
            tenis = new Tenis();
        } else {
            tenis = tenisService.getTenis(id).orElse(null);
            if (tenis == null) {
                return "redirect:/tenis/listado";
            }
        }

        model.addAttribute("tenis", tenis);
        return "/tenis/modifica";
    }
}
