import { CATEGORIES_LISTS_ROUTE } from '@/app/router';
import { CATEGORIES_TABLE, CategoryRecord } from '@/library/powersync/AppSchema';
import { List, styled } from '@mui/material';
import { usePowerSync, useQuery } from '@powersync/react';
import { useNavigate } from 'react-router-dom';
import { ListItemWidget } from './ListItemWidget';

export type CategoryListsWidgetProps = {
  selectedId?: string;
};

export function CategoryListsWidget(props: CategoryListsWidgetProps) {
  const powerSync = usePowerSync();
  const navigate = useNavigate();

  const { data: categories } = useQuery<CategoryRecord>(`
      SELECT 
        ${CATEGORIES_TABLE}.*
      FROM 
        ${CATEGORIES_TABLE}
      ORDER BY
        name;
  `);

  const deleteCategory = async (id: string) => {
    await powerSync.writeTransaction(async (tx) => {
      await tx.execute(`DELETE FROM ${CATEGORIES_TABLE} WHERE categorie_id = ?`, [id]);
    });
  };

  return (
    <S.Container>
      {categories.map((category) => (
        <ListItemWidget
          key={category.categorie_id}
          title={category.name ?? ''}
          description={category.image ? 'Has image' : 'No image'}
          image={category.image ?? ''}
          selected={category.categorie_id === props.selectedId}
          onDelete={() => deleteCategory(category.categorie_id ?? '')}
          onPress={() => {
            navigate(CATEGORIES_LISTS_ROUTE + '/' + category.categorie_id);
          }}
        />
      ))}
    </S.Container>
  );
}

export namespace S {
  export const Container = styled(List)`
    padding: 16px;
  `;
}
