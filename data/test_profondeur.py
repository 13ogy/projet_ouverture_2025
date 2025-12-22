import pandas as pd
import matplotlib.pyplot as plt

def plot_courbes_moyennes(csv_path):
    df = pd.read_csv(csv_path)

    # Calcul des moyennes
    moyennes = (
        df.groupby(["model", "n"])["avg_leaf_depth"]
        .mean()
        .reset_index()
    )

    couleurs = {
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
            subset["avg_leaf_depth"],
            label=structure,
            color=couleur,
            marker="o"
        )

    plt.xlabel("Taille (n)")
    plt.ylabel("profondeur moyenne des feuilles")
    plt.title("Profondeur moyenne des feuilles en fonction de la taille")
    plt.legend()
    plt.grid(True)

    plt.savefig("profondeur_moyenne_feuilles.png", dpi=300, bbox_inches="tight")
    plt.close()

plot_courbes_moyennes("experiments.csv")