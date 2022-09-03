import logging
import os
import argparse

from modelpkg.construct import (
    Model,
    simulate_salaries
)


# Directory for model artifacts: uses 'DIR_MODEL_LOCAL', when
# when set, i.e. when training runs locally. Otherwise
# the Sagemaker default (=/opt/ml/model).
DIR_MODEL = os.getenv('DIR_MODEL_LOCAL') or '/opt/ml/model'

if __name__ == "__main__":

    parser = argparse.ArgumentParser()

    parser.add_argument("--n_obs",
                        type=int,
                        default=10000,
                        help="number of observations")

    args = parser.parse_args()

    logging.basicConfig(level=logging.INFO)
    logger = logging.getLogger("Model training")

    # simulate data for model training
    age, salary = simulate_salaries(n=args.n_obs)

    # train model from scratch and save to file
    m = Model()
    m.train(age, salary)
    rmse = m.evaluate(age, salary)

    # log algorithm metrics => collect with training job
    logger.info(f'Train_RMSE={rmse}')

    os.makedirs(DIR_MODEL, exist_ok=True)
    m.save(dir=DIR_MODEL)
