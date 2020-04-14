import tabula
import pandas as pd
import click


def read_pdf_and_get_all_dataframes(filename, password):
    """
    read pdf and get all dataframes
    """
    # tables will have the list of all the dataframes
    tables = tabula.read_pdf(filename, pages = "all", password=password)
    
    # we need to make a single dataframe
    statement_df = pd.concat(tables)
    return statement_df


def get_amount(string):
    """Get amount from the string.

    Generally string is in the format '230.45 Dr'
    """
    for s in string.split():
        try:
            return float(s.replace(',',''))
        except AttributeError:
            pass


def normalise_to_numbers(statement_df):
    """Make dr to + and cr to -"""
    statement_df['DR'] = statement_df['Amount (Rs.)'].apply(lambda x: get_amount(x) if 'Dr' in x else None)
    statement_df['CR'] = statement_df['Amount (Rs.)'].apply(lambda x: get_amount(x) if 'Cr' in x else None)
    statement_df = statement_df.fillna(0)
    statement_df['final_amounts'] = statement_df.apply(lambda x: get_final_amounts(x.DR, x.CR), axis=1)
    return statement_df


def get_final_amounts(debit, credit):
    """We are going to assume that credit is positive and debit is negative."""
    return debit - credit


def normalise_business_details(statement_df):
    """clean up the transaction details to get the list of business where money spent"""
    # this is because the details generally come in the below format
    # DUNZO DIGITAL PRIVATE GURGAON IND - Ref No: MT200900083000010023679
    statement_df['business'] = statement_df['Transaction Details'].apply(lambda x: x.split()[0] + " " + x.split()[1])
    different_expenses = statement_df.groupby('business')['final_amounts'].sum()
    return different_expenses


@click.command()
@click.option('--filename', help='pass the name of the pdf cc statement recieved from the bank')
@click.option('--password', help='password to open the pdf file')
def main(filename, password):
    """SImple program to understand where i am spending my money."""
    statement_df = read_pdf_and_get_all_dataframes(filename, password)
    statement_df = normalise_to_numbers(statement_df)
    expenses_df = normalise_business_details(statement_df)
    print(expenses_df)


if __name__ == "__main__":
    main()

