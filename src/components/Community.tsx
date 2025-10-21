import { Card } from "@/components/ui/card";
import volunteerIcon from "@/assets/volunteer-icon.png";

const Community = () => {
  const engagements = [
    {
      organization: "Linkee Bordeaux",
      year: "2023-2024",
    },
    {
      organization: "Librairie-café Le Mot de tasse",
      year: "2020",
    },
    {
      organization: "Coach pour le club de soccer des Caravelles de Sainte-Foy",
      year: "2018",
    },
    {
      organization: "Carnaval d'hiver de Québec",
      year: "2015-2017",
    },
    {
      organization: "Bibliothèque de l'école primaire Saint-Michel à Sillery",
      year: "2016",
    },
    {
      organization: "Héma-Québec",
      year: "2014",
    },
  ];

  return (
    <section id="community" className="py-20 px-4 bg-muted/30">
      <div className="container mx-auto max-w-4xl">
        <div className="text-center mb-12">
          <img
            src={volunteerIcon}
            alt="Icône bénévolat"
            className="h-20 w-20 mx-auto mb-6"
          />
          <h2 className="text-4xl font-bold bg-gradient-to-r from-primary to-primary-glow bg-clip-text text-transparent">
            Engagement communautaire
          </h2>
        </div>
        <Card className="p-8 shadow-[var(--shadow-elegant)]">
          <div className="space-y-6">
            {engagements.map((engagement, index) => (
              <div
                key={index}
                className="flex items-start justify-between border-b border-border pb-4 last:border-0 last:pb-0 hover:bg-muted/30 transition-colors p-3 rounded-lg"
              >
                <div className="flex-1">
                  <h3 className="text-lg font-semibold text-foreground">
                    {engagement.organization}
                  </h3>
                </div>
                <span className="text-primary font-medium whitespace-nowrap ml-4">
                  {engagement.year}
                </span>
              </div>
            ))}
          </div>
        </Card>
      </div>
    </section>
  );
};

export default Community;
