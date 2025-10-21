import { Card } from "@/components/ui/card";
import { Globe, Home, Code2, BookOpen, Star, ThumbsUp } from "lucide-react";

const Achievements = () => {
  const achievements = [
    {
      icon: Globe,
      title: "Mobilité",
      description: "Science Po Bordeaux (2023-24)",
    },
    {
      icon: Home,
      title: "Pavillon",
      description: "De Koninck",
    },
    {
      icon: Code2,
      title: "Compétences techniques",
      description: "Développement web, HTML/CSS, gestion de contenu sur GitHub Pages, veille stratégique et analyse de discours",
    },
    {
      icon: BookOpen,
      title: "Langues",
      description: "Français (maternel), Anglais (expert), Espagnol (intermédiaire), R (intermédiaire)",
    },
    {
      icon: Star,
      title: "Intérêts",
      description: "Populisme, politique québécoise et canadienne, gouvernance au Moyen-Orient, présidentialisme sud-américain, sphère politico-culturelle française",
    },
    {
      icon: ThumbsUp,
      title: "Eurostep 2024",
      description: "Bordeaux - Lisbonne en pouce (en 99h)",
    },
  ];

  return (
    <section id="achievements" className="py-20 px-4 bg-muted/30">
      <div className="container mx-auto max-w-6xl">
        <h2 className="text-4xl font-bold mb-12 text-center bg-gradient-to-r from-primary to-primary-glow bg-clip-text text-transparent">
          Mes réalisations
        </h2>
        <div className="grid md:grid-cols-2 lg:grid-cols-3 gap-6">
          {achievements.map((item, index) => (
            <Card
              key={index}
              className="p-6 hover:shadow-[var(--shadow-elegant)] transition-all duration-300 hover:-translate-y-1"
            >
              <item.icon className="h-12 w-12 text-primary mb-4" />
              <h3 className="text-xl font-semibold mb-2">{item.title}</h3>
              <p className="text-muted-foreground">{item.description}</p>
            </Card>
          ))}
        </div>
      </div>
    </section>
  );
};

export default Achievements;
