import { Card } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Mail, Linkedin, Github } from "lucide-react";

const Contact = () => {
  return (
    <section id="contact" className="py-20 px-4 bg-muted/30">
      <div className="container mx-auto max-w-2xl">
        <h2 className="text-4xl font-bold mb-12 text-center bg-gradient-to-r from-primary to-primary-glow bg-clip-text text-transparent">
          Me contacter
        </h2>
        <Card className="p-8 text-center shadow-[var(--shadow-elegant)]">
          <Mail className="h-16 w-16 text-primary mx-auto mb-6" />
          <h3 className="text-2xl font-semibold mb-4">Des questions?</h3>
          <p className="text-muted-foreground mb-6">
            Vous avez un projet en tête ? N'hésitez pas à me contacter pour en discuter.
          </p>
          <div className="flex flex-col sm:flex-row gap-4 justify-center">
            <Button
              size="lg"
              className="bg-primary hover:bg-primary-glow transition-all shadow-[var(--shadow-elegant)]"
              asChild
            >
              <a href="mailto:watellep@gmail.com">
                <Mail className="mr-2 h-5 w-5" />
                Envoyer un courriel
              </a>
            </Button>
            <Button
              size="lg"
              variant="outline"
              className="transition-all hover:shadow-[var(--shadow-elegant)]"
              asChild
            >
              <a
                href="https://www.linkedin.com/in/philippe-olivier-watelle/"
                target="_blank"
                rel="noopener noreferrer"
              >
                <Linkedin className="mr-2 h-5 w-5" />
                LinkedIn
              </a>
            </Button>
            <Button
              size="lg"
              variant="outline"
              className="transition-all hover:shadow-[var(--shadow-elegant)]"
              asChild
            >
              <a
                href="https://github.com/watellephil"
                target="_blank"
                rel="noopener noreferrer"
              >
                <Github className="mr-2 h-5 w-5" />
                GitHub
              </a>
            </Button>
          </div>
        </Card>
      </div>
    </section>
  );
};

export default Contact;
