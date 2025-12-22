import pandas as pd
import matplotlib.pyplot as plt

def plot_courbes_moyennes(csv_path):
    df = pd.read_csv(csv_path)

    # Calcul des moyennes
    moyennes = (
        df.groupby(["model", "n"])["gen_time_ms"]
        .mean()
        .reset_index()
    )

    couleurs = {
        #"remy_naif": "red",
        "remy_lineaire": "blue",
        "abr": "green"
    }

    plt.figure()

    for structure, couleur in couleurs.items():
        subset = moyennes[moyennes["model"] == structure]

        # Important : trier par taille
        subset = subset.sort_values("n")

        plt.plot(
            subset["n"],
            subset["gen_time_ms"],
            label=structure,
            color=couleur,
            marker="o"
        )

    plt.xlabel("Taille (n)")
    plt.ylabel("Temps moyen (ms)")
    plt.title("Temps moyen de génération en fonction de la taille")
    plt.legend()
    plt.grid(True)

    plt.savefig("temps_moyen_vs_taille_sans_naif.png", dpi=300, bbox_inches="tight")
    plt.close()

plot_courbes_moyennes("experiments.csv")