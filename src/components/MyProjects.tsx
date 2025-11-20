import React from "react";
import { Link } from "react-router-dom";

const MyProjects = () => {
  return (
    <section id="my-projects" className="py-20 px-4">
      <div className="container mx-auto max-w-6xl">
        <h2 className="text-4xl font-bold mb-12 text-center bg-gradient-to-r from-primary to-primary-glow bg-clip-text text-transparent">
          Mes projets
        </h2>
        <div className="flex justify-center">
          <Link to="/projet-a">
            <img 
              src="/documents/image_projet.webp" 
              alt="Image du projet A" 
              className="rounded-lg shadow-lg hover:shadow-xl transition-shadow duration-300"
            />
          </Link>
        </div>
      </div>
    </section>
  );
};

export default MyProjects;
