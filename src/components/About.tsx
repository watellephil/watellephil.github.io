import { Card } from "@/components/ui/card";

const About = () => {
  return (
    <section id="about" className="py-20 px-4 bg-muted/10">
      <div className="container mx-auto max-w-4xl">
        <h2 className="text-4xl font-bold mb-6 text-center bg-gradient-to-r from-primary to-primary-glow bg-clip-text text-transparent">
          À propos de moi
        </h2>

        {/* Portrait stylé moins zoomé */}
        <div className="w-48 md:w-64 mx-auto overflow-hidden rounded-xl shadow-2xl transform transition-transform duration-500 hover:scale-102 mb-8">
          <img
            src="documents/moi.JPG"
            alt="Profil"
            className="w-full h-auto object-contain object-center"
          />
        </div>

        {/* Texte de présentation */}
        <Card className="p-8 shadow-[var(--shadow-elegant)]">
          <p className="text-lg text-foreground/80 leading-relaxed mb-6">
            Étudiant à la maîtrise en science politique. Bonjour, je m'appelle Philippe-Olivier Watelle. 
            Je suis étudiant à l'Université Laval, où je m'intéresse aux sciences politiques et aux enjeux 
            contemporains de la gouvernance mondiale. Ce site présente mes projets académiques, 
            mes travaux de recherche et certaines réflexions personnelles.
          </p>
          <p className="text-lg text-foreground/80 leading-relaxed">
            Passionné par les relations internationales et les dynamiques politiques mondiales, 
            j'aime analyser les enjeux géopolitiques tout en développant mes compétences académiques. 
            En dehors des études, je pratique le soccer, le vélo, l'escalade et la pêche, ce qui me permet 
            de garder un équilibre et de développer esprit d'équipe, endurance et patience.
          </p>
        </Card>
      </div>
    </section>
  );
};

export default About;
