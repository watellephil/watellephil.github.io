import React from "react";

const Projects = () => {
  const projects = [
    {
      title: "CV",
      description: "Cliquer pour voir mon CV",
      imageUrl: "documents/photo-cv-2025.jpg", // plus besoin de 'public/' ici
      link: "documents/2025_cv_po_watelle.pdf",
    },
  ];

  return (
    <section id="projects" className="py-20 px-4">
      <div className="container mx-auto max-w-6xl">
        <h2 className="text-4xl font-bold mb-12 text-center bg-gradient-to-r from-primary to-primary-glow bg-clip-text text-transparent">
          Mon CV
        </h2>
        <div className="grid md:grid-cols-2 lg:grid-cols-3 gap-6">
          {projects.map((project, index) => (
            <a
  key={index}
  href={project.link}
  target="_blank"
  rel="noopener noreferrer"
  className="flex justify-center border rounded-lg overflow-hidden hover:shadow-lg transition"
>
  <img
    src={project.imageUrl}
    alt={project.title}
    className="w-full h-auto max-w-xs"
  />
</a>
          ))}
        </div>
      </div>
    </section>
  );
};

export default Projects;
