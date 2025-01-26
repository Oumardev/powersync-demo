import {
  Box,
  Dialog,
  DialogActions,
  DialogContent,
  DialogContentText,
  DialogTitle,
  TextField,
  Button
} from '@mui/material';
import AddIcon from '@mui/icons-material/Add';
import { usePowerSync } from '@powersync/react';
import React from 'react';
import { NavigationPage } from '@/components/navigation/NavigationPage';
import { CategoryListsWidget } from '@/components/widgets/TodoListsWidget';
import { CATEGORIES_TABLE } from '@/library/powersync/AppSchema';
import { useConnector } from '@/components/providers/SystemProvider';
import * as S from './styles';

export default function CategoryListsPage() {
  const powerSync = usePowerSync();
  const connector = useConnector();
  const [showPrompt, setShowPrompt] = React.useState(false);
  const nameInputRef = React.useRef<HTMLInputElement>();

  const createNewCategory = async () => {
    const name = nameInputRef.current?.value;

    const userID = connector?.userId;
    if (!userID) {
      throw new Error(`Could not create new lists, no userID found`);
    }

    if (!name) {
      return;
    }

    try {
      console.log('Creating new category: ', name);
      const res = await powerSync.execute(
        `INSERT INTO ${CATEGORIES_TABLE} (id, name, image) VALUES (uuid(), ?, ?) RETURNING *`,
        [name, '']
      );

      const resultRecord = res.rows?.item(0);
      if (!resultRecord) {
        throw new Error('Could not create list');
      }

      setShowPrompt(false);
    } catch (error) {
      console.error(error);
    }
  };

  return (
    <NavigationPage title="Categories">
      <Box>
        <S.FloatingActionButton onClick={() => setShowPrompt(true)}>
          <AddIcon />
        </S.FloatingActionButton>
        <Box>
          <CategoryListsWidget />
        </Box>
        <Dialog
          open={showPrompt}
          onClose={() => {
            setShowPrompt(false);
          }}
          aria-labelledby="alert-dialog-title"
          aria-describedby="alert-dialog-description">
          <DialogTitle id="alert-dialog-title">{'Create Category'}</DialogTitle>
          <DialogContent>
            <DialogContentText id="alert-dialog-description">Enter a name for the new category</DialogContentText>
            <TextField sx={{ marginTop: '10px' }} fullWidth inputRef={nameInputRef} label="Category Name" autoFocus />
          </DialogContent>
          <DialogActions>
            <Button onClick={() => setShowPrompt(false)}>Cancel</Button>
            <Button onClick={createNewCategory} autoFocus>
              Create
            </Button>
          </DialogActions>
        </Dialog>
      </Box>
    </NavigationPage>
  );
}
