import React from 'react';
import { Link } from 'react-router-dom';

const ProjectA = () => {
  return (
    <div className="container mx-auto px-4 py-8">
      <h1 className="text-4xl font-bold mb-4">Détails du Projet A</h1>
      <p className="mb-4">
        Cette page contiendra les détails du projet A. Le contenu est en cours de rédaction.
      </p>
      <Link to="/" className="text-primary hover:underline">
        Retour à l'accueil
      </Link>
    </div>
  );
};

export default ProjectA;
