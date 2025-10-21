import { ArrowDown } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Link } from "react-router-dom";

const Hero = () => {
  const scrollToSection = (id: string) => {
    const element = document.getElementById(id);
    if (element) {
      element.scrollIntoView({ behavior: "smooth" });
    }
  };

  return (
    <section
      id="hero"
      className="min-h-screen flex items-center justify-center px-4 relative"
      style={{ backgroundImage: "url('/documents/lac.jpeg')", backgroundSize: 'cover', backgroundPosition: 'center' }}
    >
      <div className="container mx-auto text-center">
        <div className="animate-fade-in">
          <h1 className="text-5xl md:text-7xl font-bold mb-6 bg-gradient-to-r from-primary to-primary-glow bg-clip-text text-transparent">
            Philippe-Olivier Watelle
          </h1>
          <p className="text-xl md:text-2xl text-muted-foreground mb-8 max-w-2xl mx-auto">
            Étudiant à la maîtrise en science politique
          </p>
          <p className="text-lg md:text-xl text-muted-foreground mb-8 max-w-2xl mx-auto italic">
  J'aime la politique, l'histoire, l'urbanisme,{" "}
  <Link to="/velo" className="underline text-blue-600 hover:text-blue-800">
    le vélo
  </Link>
  , et la bouffe !
</p>
          <Button
            onClick={() => scrollToSection("about")}
            size="lg"
            className="bg-primary hover:bg-primary-glow transition-all shadow-[var(--shadow-elegant)]"
          >
            Découvrir mon profil
            <ArrowDown className="ml-2 h-5 w-5" />
          </Button>
        </div>
      </div>

      <div className="absolute bottom-8 left-1/2 transform -translate-x-1/2 animate-bounce">
        <ArrowDown className="h-6 w-6 text-muted-foreground" />
      </div>
    </section>
  );
};

export default Hero;
