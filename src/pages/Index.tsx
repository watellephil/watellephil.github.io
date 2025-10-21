import Navigation from "@/components/Navigation.tsx";
import Hero from "@/components/Hero.tsx";
import About from "@/components/About.tsx";
import Skills from "@/components/Skills.tsx";
import Community from "@/components/Community.tsx";
import Projects from "@/components/Projects.tsx";
import Contact from "@/components/Contact.tsx";
import Footer from "@/components/Footer.tsx";
const Index = () => {
  return (
    <div className="min-h-screen">
      <Navigation />
      <Hero />
      <About />
      <Skills />
      <Community />
      <Projects />
      <Contact />
      <Footer />
    </div>
  );
};

export default Index;
