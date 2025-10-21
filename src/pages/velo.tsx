import React from 'react';
import { MapContainer, TileLayer, Marker, Popup } from 'react-leaflet';
import 'leaflet/dist/leaflet.css';
import L from 'leaflet';

// Fix des icônes par défaut de Leaflet avec des URLs directes
delete L.Icon.Default.prototype._getIconUrl;
L.Icon.Default.mergeOptions({
  iconRetinaUrl: 'https://unpkg.com/leaflet@1.9.4/dist/images/marker-icon-2x.png',
  iconUrl: 'https://unpkg.com/leaflet@1.9.4/dist/images/marker-icon.png',
  shadowUrl: 'https://unpkg.com/leaflet@1.9.4/dist/images/marker-shadow.png',
});

const Velo = () => {
  return (
    <div className="w-full h-screen">
      <MapContainer center={[48.8566, 2.3522]} zoom={3} className="w-full h-full">
        <TileLayer url="https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png" />
        
        {/* Exemple de marqueurs pour tes voyages */}
        <Marker position={[44.8333, -0.5666]}>
          <Popup>Bordeaux - La Rochelle (2024) </Popup>
        </Marker>
        <Marker position={[46.8858, -71.2327]}>
          <Popup>Québec - Rimouski (2019-20-21-24-25)</Popup>
        </Marker>
        <Marker position={[48.607697, -65.846256]}>
          <Popup>Tour de la Gaspésie (2022) </Popup>
        </Marker>  
        <Marker position={[46.118252, -70.669230]}>
          <Popup>Québec - Saint-Georges(2022) </Popup>
        </Marker>
      </MapContainer>
    </div>
  );
};

export default Velo;