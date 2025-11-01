package com.ProyectoTenis.demo.service;

import com.ProyectoTenis.demo.domain.Tenis;
import com.ProyectoTenis.demo.repository.TenisRepository;
import java.io.IOException;
import java.nio.file.*;
import java.util.List;
import java.util.Optional;
import java.util.UUID;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

@Service
public class TenisService {

    private final String uploadFolder = "uploads/imagenes/";

    @Autowired
    private TenisRepository tenisRepository;

    @Transactional(readOnly = true)
    public List<Tenis> getTenis() {
        return tenisRepository.findAll();
    }

    @Transactional(readOnly = true)
    public Optional<Tenis> getTenis(Long id) {
        return tenisRepository.findById(id);
    }

    @Transactional
    public void save(Tenis tenis, MultipartFile imagenFile) {
        tenis = tenisRepository.save(tenis);

        if (imagenFile != null && !imagenFile.isEmpty()) {
            try {
                String nombreArchivo = UUID.randomUUID() + "_" + imagenFile.getOriginalFilename();
                Path ruta = Paths.get(uploadFolder + nombreArchivo);
                Files.createDirectories(ruta.getParent());
                imagenFile.transferTo(ruta.toFile());

                tenis.setImagen("/" + uploadFolder + nombreArchivo);
                tenisRepository.save(tenis);
            } catch (IOException e) {
                throw new RuntimeException("Error al guardar la imagen: " + e.getMessage());
            }
        }
    }

    @Transactional
    public void delete(Long id) {
        if (!tenisRepository.existsById(id)) {
            throw new IllegalArgumentException("El tenis con ID " + id + " no existe.");
        }
        tenisRepository.deleteById(id);
    }
}
