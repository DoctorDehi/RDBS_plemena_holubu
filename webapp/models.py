from sqlalchemy import Column
from sqlalchemy import ForeignKey
from sqlalchemy import Integer
from sqlalchemy import String
from sqlalchemy.orm import declarative_base
from sqlalchemy.orm import relationship

Base = declarative_base()


class Plemeno(Base):
    __tablename__ = "plemena"

    id_ple = Column(Integer, primary_key=True)
    nazev = Column(String(30))
    sk_nazev = Column(String(30))
    de_nazev = Column(String(30))
    uk_nazev = Column(String(30))
    skupina = Column(Integer, ForeignKey("skupina.id_sku"), nullable=False)
    velikost = Column()
    misto_puvodu = Column()
    krouzek = Column()
    strucny_popis = Column()

    skupina_r = relationship("Skupina", back_populates="plemena")

    addresses = relationship(
        "Address", back_populates="user", cascade="all, delete-orphan"
    )

    def __repr__(self):
        return f"Plemeno(id={self.id_ple!r}, name={self.nazev!r})"


class Skupina(Base):
    __tablename__ = "skupiny"

    id_sku = Column(Integer, primary_key=True)
    nazev = Column(String, nullable=False)
    plemena = relationship("Plemeno", back_populates="skupina_r")

    def __repr__(self):
        return f"Skupina(id={self.id_sku!r}, nazev={self.nazev!r})"
